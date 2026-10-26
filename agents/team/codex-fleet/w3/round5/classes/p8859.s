# n=5 model=out iset=I1 prefix14_class=8859
mov S0, P3
cmp P1, S0
cmovge S0, P1
cmovle P3, P1
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
mov P1, S0
cmovge P0, S1
cmp P2, S0
cmovge S0, P2
cmovle P1, P2
cmp P0, P3
cmovle S1, P0
