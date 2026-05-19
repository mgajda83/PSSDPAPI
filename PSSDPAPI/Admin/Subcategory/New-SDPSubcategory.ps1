Function New-SDPSubcategory
{
	<#
	.SYNOPSIS
		Add new Subcategory

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			subcategory = @{
				name = "Wsparcie obsługi komputera"
				description = "Sub Test"
				category = @{
					id = 2701
				}
			}
		}

		$Subcategory = New-SDPSubcategory -InputData $InputData

	.EXAMPLE
		$InputData = @{
			subcategory = @{
				name = "Wsparcie obsługi komputera 2"
				description = "Sub Test 2"
			}
		}

		$Subcategory = New-SDPSubcategory -CategoryId 2701 -InputData $InputData

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
		[Parameter()]
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
		if($MyInvocation.BoundParameters.ContainsKey("CategoryId"))
		{
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "POST"
				EntityUri = "/api/v3/categories/$CategoryId/subcategories"
				InputData = $InputData
			}
		} else {
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "POST"
				EntityUri = "/api/v3/subcategories"
				InputData = $InputData
			}
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($InputData.subcategory.name,"Add new subcategory"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.subcategory
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
