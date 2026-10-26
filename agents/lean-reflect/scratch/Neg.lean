import LeanReflect.FileCert
import LeanReflect.Sort3G
open LeanReflect
example : checkFile 3 10 I1 (certFile "certs/missing.cert" 3) = true := by native_decide
