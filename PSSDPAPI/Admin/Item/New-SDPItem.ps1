Function New-SDPItem
{
	<#
	.SYNOPSIS
		Add new Item

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			item = @{
				name = "Testowy Incydent bezpieczeństwa"
				description = "Test"
				subcategory = @{
					id = 3003
				}
			}
		}

		$Item = New-SDPItem -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#add-an-user
		https://help.servicedeskplus.com/user-ci-api
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true)]
		$InputData
	)

	Begin
	{
		#Create headers
		if(!$MyInvocation.BoundParameters.ContainsKey("UriSDP"))
		{
			if($Global:UriSDP)
			{
				$UriSDP = $Global:UriSDP
			} else {
				Write-Error "UriSDP parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
		if(!$MyInvocation.BoundParameters.ContainsKey("ApiKey"))
		{
			if($Global:ApiKey)
			{
				$ApiKey = $Global:ApiKey
			} else {
				Write-Error "ApiKey parameter is required or run Set-SDPApiConnection first." -ErrorAction Stop
			}
		}
	}

	Process
	{
		$InvokeParams = @{
			UriSDP = $UriSDP
			ApiKey = $ApiKey
			Method = "POST"
			EntityUri = "/api/v3/items"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($InputData.item.name,"Add new item"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.item
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Return $Results
		}
	}

	End{}
}
