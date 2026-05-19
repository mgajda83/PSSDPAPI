Function Set-SDPSubcategory
{
	<#
	.SYNOPSIS
		Update Subcategory

	.PARAMETER SubcategoryId
		Subcategory id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			subcategory = @{
				name = "Wsparcie obsługi komputera"
				description = "Testowy"
				category = @{
					id = 2701
				}
			}
		}

		$Subcategory = Set-SDPSubcategory -SubcategoryId 3302 -InputData $InputData

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
		[Int]$SubcategoryId,
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
			EntityUri = "/api/v3/subcategories/$SubcategoryId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($SubcategoryId,"Update subcategory by id"))
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
