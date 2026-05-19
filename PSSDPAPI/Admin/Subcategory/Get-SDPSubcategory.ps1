Function Get-SDPSubcategory
{
	<#
	.SYNOPSIS
		Get subcategory

	.PARAMETER SubcategoryId
		Subcategory id

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
		$Subcategory = Get-SDPSubcategory -SubcategoryId 547

	.EXAMPLE
		557, 558 | Get-SDPSubcategory

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
		[Int]$SubcategoryId,
		[Parameter(ParameterSetName="ItemId")]
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

		if($All) { $Limit = [int]::MaxValue }
	}

	Process
	{
		if($MyInvocation.BoundParameters.ContainsKey("SubcategoryId"))
		{
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/subcategories/$SubcategoryId"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($SubcategoryId,"Get subcategory by id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.subcategory
			}
		} elseif($MyInvocation.BoundParameters.ContainsKey("CategoryId"))
		{
			#Get by ID
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/categories/$CategoryId/subcategories"
			}

			#Send request
			If ($PSCmdlet.ShouldProcess($CategoryId,"Get subcategorie by category id"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.subcategories
			}
		} else {
			#Get by Search
			$InvokeParams = @{
				UriSDP = $UriSDP
				ApiKey = $ApiKey
				Method = "GET"
				EntityUri = "/api/v3/subcategories"
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
			If ($PSCmdlet.ShouldProcess("Get subcategories by search request"))
			{
				$Result = Invoke-SDPAPIEntity @InvokeParams
				$Results = $Result.subcategories
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
