Function New-SDPRequest
{
	<#
	.SYNOPSIS
		Add new Request

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"request"= @{
				"requester"= @{
					"id"= "381"
				}
				"request_type"= @{
					"id"= 301
					"name"= "Awaria"
				}
				"category" = @{
					"id" = 904
				}
				"subcategory" = @{
					"id" = 1215
				}
				"item" = @{
					"id" = 1521
				}
				"mode"= @{
					"name" = "Web Form"
					"id" = 2
				}
				"subject"= "Testowa Awaria"
				"description"= "Awaria Serwera!"
			}
		}

		$Request = New-SDPRequest -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#add-request
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
			EntityUri = "/api/v3/requests"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($InputData.request.subject,"Add new request"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.request
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
