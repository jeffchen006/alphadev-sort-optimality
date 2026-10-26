# n=5 model=out iset=I1 prefix14_class=6590
cmp P3, P2
mov S2, P2
cmovle P2, P3
mov S0, P1
cmovge S2, P3
cmp S0, P0
cmovle S0, P0
cmovl P0, P1
cmp S2, S0
cmovge P3, S2
cmovge S2, S0
cmovg S0, P3
cmp P2, P0
mov S1, P2
