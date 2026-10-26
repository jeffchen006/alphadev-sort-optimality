# n=5 model=out iset=I1 prefix14_class=9690
cmp P2, P3
cmovg S0, P2
mov S1, P0
cmovge P2, P3
cmovg P3, S0
cmp P1, P0
cmovle S1, P1
cmovg P0, P1
mov P1, P0
cmp P0, P3
cmovle P0, P3
cmovge P1, P3
cmp P2, S1
mov P3, S1
