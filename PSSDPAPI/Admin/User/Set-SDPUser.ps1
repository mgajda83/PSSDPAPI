Function Set-SDPUser
{
	<#
	.SYNOPSIS
		Update User

	.PARAMETER UserId
		User id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"user"= @{
					"first_name" = "Michal"
					"last_name" = "Gajda"
					"name" = "Michal Gajda"
			}
		}

		$User = Set-SDPUser -UserId 54321 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://ui.servicedeskplus.com/APIDocs3/index.html#update-an-user
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
		[Int]$UserId,
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
			EntityUri = "/api/v3/users/$UserId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($UserId,"Update user by id"))
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
