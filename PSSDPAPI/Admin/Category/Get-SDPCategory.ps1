Function Get-SDPCategory
{
	<#
	.SYNOPSIS
		Get category

	.PARAMETER CategoryId
		Category id

	.PARAMETER InputData
		Custom search object.

list_info :
{
	"row_count"         : number of rows to be returned(maximum row_count = 100)
	"start_index"       : starting row index
	"sort_field"        : "fieldName"
	"sort_order"        : “asc/desc”,
	"get_total_count"   : boolean (by default it will be false)
	"has_more_rows"     : boolean (will be returned with the response)
	"total_count"       : count (will be returned with the response only)
	"search_criteria"   :  Refer search criteria object given in the attributes of List Info(For performing advanced search)
	"fields_required" : [ "list of fields required" ]
}

	.PARAMETER Limit
		Limit returned data. Default return last 100 items.

	.EXAMPLE
		$Category = Get-SDPCategory -ItemId 547

	.EXAMPLE
		557, 558 | Get-SDPCategory

	.NOTES
		Author: Michal Gajda
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low",
		DefaultParameterSetName="Search"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(ParameterSetName="ItemId",
			ValueFromPipeline)]
		[Int]$CategoryId,
		[Parameter(ParameterSetName="Search")]
		$InputData,
		[Parameter(ParameterSetName="Search")]
		[ValidateScript({$_ -is [int] -and $_ -gt 0})]
		$Limit = 100,
		[Parameter(ParameterSetName="Search")]
		[Switch]$All
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
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/categories/$CategoryId"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($CategoryId,"Get categorie by id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.category
			}
		} else {
			#Get by Search
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/categories"
				Limit = $Limit
			}
			if($MyInvocation.BoundParameters.ContainsKey("InputData"))
			{
				$InvokeParams['InputData'] = $InputData
			} else {
				$InvokeParams['InputData'] = @{
					list_info = @{
						start_index = 1
						row_count = $Limit
						sort_field = "id"
						sort_order = "desc"
					}
				}
			}

			#Send request
			If ($PSCmdlet.ShouldProcess("Get categories by search request"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.categories
			}
		}

		#Return result
		if($MyInvocation.BoundParameters.ContainsKey("Debug"))
		{
			Return $Result
		} else {
			Write-Verbose ($Results | Measure-Object).Count
			Return $Results
		}
	}

	End{}
}
