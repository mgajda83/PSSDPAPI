Function New-SDPUser
{
	<#
	.SYNOPSIS
		Add new User

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			user = @{
					first_name = "Michaello"
					last_name = "Gajdosso"
					name = "Michaello Gajdosso"
					email_id = "mgajda@sdpexample.pl"
					department = @{
						id = 20633
					}
			}
		}

		$User = New-SDPUser -InputData $InputData

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
			EntityUri = "/api/v3/users"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($InputData.user.name,"Add new user"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.user
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
