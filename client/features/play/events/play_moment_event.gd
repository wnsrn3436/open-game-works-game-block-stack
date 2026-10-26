class_name PlayMomentEvent
extends EventBase
## A moment of the run that telemetry marks: the answer to a drop, a perfect drop, the miss, a run start and the result.

enum Moment { RESPONSE, PERFECT, MISS, STARTED, RESULT }

var moment: Moment = Moment.RESPONSE
