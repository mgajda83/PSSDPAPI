Function Set-SDPRequestNote
{
	<#
	.SYNOPSIS
		Update Request Note

	.PARAMETER NoteId
		Note id

	.PARAMETER RequestId
		Request id

	.PARAMETER InputData
		Input data as hashtable or JSON string

	.EXAMPLE
		$InputData = @{
			"note" = @{
				"description" = "Note edited description"
				"add_to_linked_requests" = $false
				"mark_first_response" = $false
				"notify_technician" = $false
				"show_to_requester" = $false
			}
		}
		Set-SDPRequestNote -RequestId 54321 -NoteId 12345 -InputData $InputData

	.NOTES
		Author: Michal Gajda

	.LINK
		https://www.manageengine.com/products/service-desk/sdpod-v3-api/requests/request_note.html#edit-request-note
	#>
	[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="Low"
	)]
	param (
		[String]$UriSDP,
		[String]$ApiKey,
		[Parameter(Mandatory=$true)]
		[Int]$NoteId,
		[Parameter(Mandatory=$true,
			ValueFromPipeline)]
		[Int]$RequestId,
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
			EntityUri = "/api/v3/requests/$RequestId/notes/$NoteId"
			InputData = $InputData
		}

		#Send request
		If ($PSCmdlet.ShouldProcess($NoteId,"Update request note by id"))
		{
			$Result = Invoke-SDPAPIEntity @InvokeParams
			$Results = $Result.note
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
