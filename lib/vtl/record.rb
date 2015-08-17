require 'hashie'

class VTL::Record < Hashie::Mash

  include Hashie::Extensions::Coercion

  ACTION_VALUES    = %w( identify voterPollCheckin cancelVoterRecord start discard complete submit receive approve reject sentToVoter returnedUndelivered ).map(&:downcase)
  FORM_VALUES      = %w( VoterRegistration VoterRegistrationAbsenteeRequest VoterRecordUpdate VoterRecordUpdateAbsenteeRequest AbsenteeRequest AbsenteeBallot ProvisionalBallot PollBookEntry VoterCard ).map(&:downcase)
  FORM_NOTE_VALUES = %w( handMarked onlineGeneratedPaper onlineGeneratedPaperless FPCA FWAB NVRAmotorVehicles NVRAother stateForm thirdParty trackingCodeNone trackingCodeMatch trackingCodeNoMatch ).map(&:downcase)
  NOTES_VALUES     = %w(
    acceptReactivate acceptDuplicate acceptTransferIn acceptNewRequest acceptChange
    rejectLate rejectUnsigned rejectIncomplete rejectFelonyConviction rejectIncapacitated rejectUnderage rejectCitizenship rejectPreviousVoteAbsentee rejectPreviousVote rejectAdministrative rejectIneligible
    cancelUnderage cancelDuplicate cancelCitizenship cancelOther cancelTransferOut cancelDeceased cancelFelonyConviction cancelIncapacitated
    postalReceived personalReceived electronicReceived faxReceived
    postalSent emailSent electronicSent faxSent
    onlineVoterReg onlineBalloting ).map(&:downcase)

  ATTRS = {
    'voterid'      => { name: 'voter_id' },
    'date'         => { name: 'date' },
    'action'       => { name: 'action' },
    'form'         => { name: 'form' },
    'formNote'     => { name: 'formNote' },
    'leo'          => { name: 'leo' },
    'notes'        => { name: 'notes', type: :array },
    'comment'      => { name: 'comment' },
    'election'     => { name: 'election' },
    'jurisdiction' => { name: 'jurisdiction' }
  }

  def errors
    if !defined? @errors
      @errors = []
      requried %w( voterid date jurisdiction action )
      valid :action, ACTION_VALUES
      valid :form, FORM_VALUES
      valid :form_note, FORM_NOTE_VALUES
      valid :notes, NOTES_VALUES
    end

    @errors
  end

  def valid?
    errors.empty?
  end

  private

  def required(*fields)
    fields.each do |f|
      @errors << "#{f} is required" if blank?(self.send(f))
    end
  end

  def valid(field, values)
    v = self.send(field)
    @errors << "#{field} is invalid" if !v.nil? and !values.include?(v.downcase)
  end

  def blank?(f)
    f.nil? or f.empty?
  end

end
