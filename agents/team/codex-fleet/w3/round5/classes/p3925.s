# n=5 model=out iset=I1 prefix14_class=3925
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovle P0, P3
cmp P2, P1
cmovg S0, P2
cmovle S0, P1
cmovl P1, P2
cmp P1, S1
cmovge P3, S1
cmovg S1, P1
cmovge P1, P3
mov S2, P0
cmp S0, S2
