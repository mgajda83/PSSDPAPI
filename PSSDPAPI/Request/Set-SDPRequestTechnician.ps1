Function Set-SDPRequestTechnician
{
	<#
	.SYNOPSIS
		Assign request to group or technician

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.PARAMETER Pickup
		Pickup request on your name as a technician

	.EXAMPLE
		$InputData = @{
			"request"= @{
				"group"= @{
					"name"= "It"
				}
				"technician"= @{
					"id"= "381"
					"name"= "Gajda Michał"
				}
			}
		}

		$Request = Set-SDPRequestTechnican -RequestId 54321 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#assign-request
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
		DefaultParameterSetName="Pickup"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
		[Parameter(ParameterSetName="Assign",
			Mandatory=$true)]
		$InputData,
		[Parameter(ParameterSetName="Pickup",
			Mandatory=$true)]
		[Switch]$Pickup
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
		if($MyInvocation.BoundParameters.ContainsKey("Pickup"))
		{
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "PUT"
				EntityUri = "/api/v3/requests/$RequestId/pickup"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($RequestId,"Pickup request id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.response_status
			}
		} else {
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "PUT"
				EntityUri = "/api/v3/requests/$RequestId/assign"
				InputData = $InputData
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($RequestId,"Assign request id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.response_status
			}
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

Set-Alias -Name Assign-SDPRequest -Value Set-SDPRequestTechnician
Set-Alias -Name Pickup-SDPRequest -Value Set-SDPRequestTechnician
