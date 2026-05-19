Function Set-SDPCategory
{
	<#
	.SYNOPSIS
		Update Category

	.PARAMETER CategoryId
		Category id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			category = @{
				name = "Wsparcie obsługi komputera"
				description = "Testowy"
			}
		}

		$Category = Set-SDPCategory -CategoryId 54321 -InputData $InputData

	.NOTES
		Author: Michal Gajda
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$CategoryId,
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
			Method = "PUT"
			EntityUri = "/api/v3/categories/$CategoryId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($CategoryId,"Update category by id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.category
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
