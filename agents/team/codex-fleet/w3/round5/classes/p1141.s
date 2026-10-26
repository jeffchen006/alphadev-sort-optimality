# n=5 model=out iset=I1 prefix14_class=1141
cmp P0, P2
mov S1, P3
cmovle S0, P0
cmovle P0, P2
cmovle P2, S0
cmp P1, S1
cmovg P3, P1
cmovg P1, S1
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovge S1, P3
mov P3, P2
cmp P1, P3
