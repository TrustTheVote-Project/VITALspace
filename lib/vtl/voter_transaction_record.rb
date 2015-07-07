require 'timeliness'

class VTL::VoterTransactionRecord

  attr_reader :voter_id
  attr_reader :date
  attr_reader :action
  attr_reader :form
  attr_reader :form_note
  attr_reader :jurisdiction
  attr_reader :leo
  attr_reader :notes
  attr_reader :comment
  attr_reader :election

# <xs:element name="voterid"      type="xs:string" />
# <xs:element name="date"         type="xs:dateTime" />
# <xs:element name="action"       type="actionType" />
# <xs:element name="form"         type="formType" minOccurs="0" />
# <xs:element name="formNote"     type="formNoteType" minOccurs="0" />
# <xs:element name="jurisdiction" type="xs:string" />
# <xs:element name="leo"          type="xs:string" minOccurs="0" />
# <xs:element name="notes"        type="noteType"  minOccurs="0" />
# <xs:element name="comment"      type="xs:string" minOccurs="0" />
# <xs:element name="election"     type="xs:string" minOccurs="0" />

# actionType:
      # <!-- Two kinds of actions: (a) require form (b) no form involved.
      #      Really should be 2 separate types, and two separate options for VTR
      #      (a) form VTR where form is required (rather than optional at present
      #      (b) noform VTR where form is absent
      #      However, backward compatibility -->

      # <!--  Type A - actions that do not involve a form -->
      # <xs:enumeration value="identify" /> <!-- remove after backward compat check -->
      # <xs:enumeration value="voterPollCheckin" />
      # <xs:enumeration value="cancelVoterRecord" />
      # <xs:enumeration value="start" />

      # <!-- Type B: actions that require a form -->
      # <xs:enumeration value="discard" />
      # <xs:enumeration value="complete" />
      # <xs:enumeration value="submit" />
      # <xs:enumeration value="receive" />
      # <xs:enumeration value="approve" />
      # <xs:enumeration value="reject" />
      # <xs:enumeration value="sentToVoter" />
      # <xs:enumeration value="returnedUndelivered" />


# formType:
      # <xs:enumeration value="VoterRegistration" />
      # <xs:enumeration value="VoterRegistrationAbsenteeRequest" />
      # <xs:enumeration value="VoterRecordUpdate" />
      # <xs:enumeration value="VoterRecordUpdateAbsenteeRequest" />
      # <xs:enumeration value="AbsenteeRequest" />
      # <xs:enumeration value="AbsenteeBallot" />
      # <xs:enumeration value="ProvisionalBallot" />
      # <xs:enumeration value="PollBookEntry" />
      # <xs:enumeration value="VoterCard" />

# formNoteType:
      # <!-- Used to track use of OVR -->
      # <xs:enumeration value="handMarked" />
      # <xs:enumeration value="onlineGeneratedPaper" />
      # <xs:enumeration value="onlineGeneratedPaperless" />

      # <!-- Used to differentiate various kinds of forms -->
      # <xs:enumeration value="FPCA" />       <!-- Note: FPCA can be OVR -->
      # <xs:enumeration value="FWAB" />
      # <xs:enumeration value="NVRAmotorVehicles" />
      # <xs:enumeration value="NVRAother" />
      # <xs:enumeration value="stateForm" />
      # <xs:enumeration value="thirdParty" />

      # <!-- Used to track use tracking codes for onlineGeneratedPaper -->
      # <xs:enumeration value="trackingCodeNone" />
      # <xs:enumeration value="trackingCodeMatch" />
      # <xs:enumeration value="trackingCodeNoMatch" />

# noteType:
      # <!-- Trackable sub cases for accepting a VR or AB requests -->
      # <xs:enumeration value="acceptReactivate" />
      # <xs:enumeration value="acceptDuplicate" />
      # <xs:enumeration value="acceptTransferIn" />
      # <xs:enumeration value="acceptNewRequest" />
      # <xs:enumeration value="acceptChange" />

      # <!-- Reasons for rejecting a VR or AB requests, and absentee or provisional ballots -->
      # <xs:enumeration value="rejectLate" />
      # <xs:enumeration value="rejectUnsigned" />
      # <xs:enumeration value="rejectIncomplete" />
      # <xs:enumeration value="rejectFelonyConviction" />
      # <xs:enumeration value="rejectIncapacitated" />
      # <xs:enumeration value="rejectUnderage" />
      # <xs:enumeration value="rejectCitizenship" />

      # <!-- Reasons for rejecting Absentee or provisional ballots -->
      # <xs:enumeration value="rejectPreviousVoteAbsentee" />
      # <xs:enumeration value="rejectPreviousVote" />
      # <xs:enumeration value="rejectAdministrative" />
      # <xs:enumeration value="rejectIneligible" />

      # <!-- Reasons for cancelling reg -->
      # <xs:enumeration value="cancelUnderage" />
      # <xs:enumeration value="cancelDuplicate" />
      # <xs:enumeration value="cancelCitizenship" />
      # <xs:enumeration value="cancelOther" />
      # <xs:enumeration value="cancelTransferOut" />
      # <xs:enumeration value="cancelDeceased" />
      # <xs:enumeration value="cancelFelonyConviction" />
      # <xs:enumeration value="cancelIncapacitated" />

      # <!-- Notes for how a form or ballot was received -->
      # <xs:enumeration value="postalReceived" />
      # <xs:enumeration value="personalReceived" />
      # <xs:enumeration value="electronicReceived" />
      # <xs:enumeration value="faxReceived" />

      # <!-- Notes for how a blank ballot was sent to voter -->
      # <xs:enumeration value="postalSent" />
      # <xs:enumeration value="emailSent" />
      # <xs:enumeration value="electronicSent" />
      # <xs:enumeration value="faxSent" />

      # <!-- Notes for types of non-documents (online systems, not forms) that a voter can identify to -->
      # <xs:enumeration value="onlineVoterReg" />
      # <xs:enumeration value="onlineBalloting" />

  def initialize(node)
    @voter_id     = node.at_css('voterid').content
    @date         = Timeliness.parse(node.at_css('date').content)
    @action       = node.at_css('action').content
    @form         = node.at_css('form').content
    @jurisdiction = node.at_css('jurisdiction').content
    @form_note    = value_or_nil(node, 'formNote')
    @leo          = value_or_nil(node, 'leo')
    @notes        = value_or_nil(node, 'notes')
    @comment      = value_or_nil(node, 'comment')
    @election     = value_or_nil(node, 'election')
  end

  private

  def value_or_nil(node, key)
    v = node.at_css(key)
    v && v.content
  end
end
