enum Status { Loading, Success, Error, Empty }
enum ActionStatus { Idle, Working }
enum SaveStatus { Idle, Working }
enum DeleteStatus { Idle, Working }
enum SubmitStatus { Idle, Working }

enum AllocationUnit {
  TRACK,
  CYLINDER,
  BLOCK,
  BYTE,
  KILOBYTE,
  MEGABYTE,
  RECORD
}

enum DataSetOrganization {
  PO, POU, PO_E, PS, PS_E, PS_L, PSU, VSAM, VSAM_E, HFS, ZFS, DA, DAU
}

enum JobStatus {
  ACTIVE, INPUT, OUTPUT, ALL
}
