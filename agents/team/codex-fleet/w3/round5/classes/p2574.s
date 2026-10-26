# n=5 model=out iset=I1 prefix14_class=2574
mov S0, P2
cmp S0, P3
cmovge S0, P3
cmovge P3, P2
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
cmp P3, S1
cmovg P2, P3
cmovle P2, S1
cmovg P3, S1
mov P2, P1
cmp P1, S0
