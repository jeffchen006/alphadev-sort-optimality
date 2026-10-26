# n=5 model=out iset=I1 prefix14_class=12022
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovge S0, P0
cmp P2, P1
mov S1, P3
cmovle S2, P1
cmovg S2, P2
cmovge P2, P1
cmp P3, P2
cmovle P3, P2
cmovge S1, P2
cmp S0, S2
cmovle P0, S0
