# n=5 model=out iset=I1 prefix14_class=13016
mov S0, P1
cmp P2, P1
mov S1, P0
cmovle S0, P2
cmovge P1, P2
cmp P0, P3
cmovg P0, P3
cmovle S1, P3
cmp S0, P0
cmovle S2, S0
cmovle S0, P0
cmovle P0, S2
cmp P1, S1
mov P2, S1
