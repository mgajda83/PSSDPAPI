Function Invoke-SDPAPIEntity
{
	<#
	.SYNOPSIS
		Create new API entity

	.PARAMETER EntityUri
		Entity uri

	.PARAMETER EntityResult
		Entity result attribute

	.PARAMETER Method
		REST method type

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/au/products/service-desk/sdpod-v3-api/
		https://ui.servicedeskplus.com/APIDocs3/index.html#introduction
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	Param (
		[Parameter(Mandatory=$true)]
		[String]$UriSDP,
		[Parameter(Mandatory=$true)]
		[String]$ApiKey,
		[Parameter(Mandatory=$true)]
		[ValidateSet("GET","POST","PUT","DELETE")]
		[String]$Method,
		[String]$ContentType,
		[Parameter(Mandatory=$true)]
		[String]$EntityUri,
		[Parameter()]
		[String]$EntityResult,
		[Parameter()]
		$InputData,
		[Parameter()]
		[ValidateScript({$_ -is [int] -and $_ -gt 0})]
		$Limit = 100,
		[Parameter()]
		[Switch]$SkipCertificateCheck
	)

	Begin
	{
		#Create headers
		if(!$MyInvocation.BoundParameters.ContainsKey("UriSDP")) { $UriSDP = $Global:UriSDP }
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey")) { $ApiKey = $Global:ApiKey }
		$Headers = @{"TECHNICIAN_KEY"=$ApiKey}

		Switch($Method)
		{
			"GET"       { $Action = "Get"; break }
			"POST"      { $Action = "Create"; break }
			"PUT"       { $Action = "Update"; break }
			"DELETE"    { $Action = "Remove"; break }
		}

		Write-Verbose $Limit

		$Body = $null
		if($MyInvocation.BoundParameters.ContainsKey("InputData"))
		{
			#Create body
			if($InputData -is [String])
			{
				$InputData = $InputData | ConvertFrom-Json | ConvertTo-HashTable
			}

			if($Method -eq "GET")
			{
				if($null -eq $InputData['list_info']['start_index'])    { $InputData['list_info']['start_index'] = 1 }
				if($null -eq $InputData['list_info']['row_count'])      { $InputData['list_info']['row_count'] = 100 }
				if($null -eq $InputData['list_info']['sort_field'])     { $InputData['list_info']['sort_field'] = "id" }
				if($null -eq $InputData['list_info']['sort_order'])     { $InputData['list_info']['sort_order'] = "desc" }
			}
			$Params = $InputData | ConvertTo-Json -Depth 5 -Compres
			$Body = @{input_data=$Params}
			Write-Verbose $Params
		} else {
			$InputData = @{
				list_info = @{}
			}
		}
	}

	Process
	{
		$Uri = ($UriSDP + "/" + $EntityUri) -Replace('//*','/') -Replace(':/','://')
		Write-Verbose "$Method $Uri"

		#Send request
		If ($PSCmdlet.ShouldProcess($EntityUri,"Invoke action $Action"))
		{
			if($MyInvocation.BoundParameters.ContainsKey("InputData"))
			{
				Write-Verbose "With Body"
				$Result = $null
				$Results = @()
				$RestCounter = $Limit
				do
				{
					if($Result.list_info.has_more_rows)
					{
						$InputData['list_info']['start_index'] = $Result.list_info.start_index + $Result.list_info.row_count
						$RestCounter -= $Result.list_info.row_count
						if($RestCounter -lt $Result.list_info.row_count) { $InputData['list_info']['row_count'] = $RestCounter }
						if($InputData['list_info']['start_index'] -ge $Limit) { break }

						$Params = $InputData | ConvertTo-Json -Depth 5 -Compress
						$Body = @{input_data=$Params}
						Write-Verbose $Params
					}

					$RestPrams = @{
						Method = $Method
						Uri = $Uri
						Headers = $Headers
						Body = $Body
						UseBasicParsing = $true
					}
					if($Host.Version -gt [Version]"7.2") { $RestPrams['SkipCertificateCheck'] = $Global:SkipCertificateCheck }
					if($ContentType) { $RestPrams['ContentType'] = $ContentType }
					$Result = Invoke-RestMethod @RestPrams
					$Results += $Result
					Write-Verbose "Has more rows: $($Result.list_info.has_more_rows)"
				} while($Result.list_info.has_more_rows)
				if($EntityResult)
				{
					$Results = $Results | Select-Object -ExpandProperty $EntityResult
				} else {
					$Result = $Results
				}
			} else {
				Write-Verbose "Without Body"
				$RestPrams = @{
					Method = $Method
					Uri = $Uri
					Headers = $Headers
					UseBasicParsing = $true
				}
				if($Host.Version -gt [Version]"7.2") { $RestPrams['SkipCertificateCheck'] = $Global:SkipCertificateCheck }
				if($ContentType) { $RestPrams['ContentType'] = $ContentType }
				$Result = Invoke-RestMethod @RestPrams
				$Results = $Result.$EntityResult
			}
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("EntityResult"))
		{
			Return $Results
		} else {
			Return $Result
		}
	}

	End{}
}
