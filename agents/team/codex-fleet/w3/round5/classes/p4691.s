# n=5 model=out iset=I1 prefix14_class=4691
mov S0, P0
mov S2, P2
cmp P1, S0
cmovge S0, P1
cmovl P0, P1
cmp S2, P3
cmovge P2, P3
cmovle S2, P3
cmp S0, S2
mov S1, P0
cmovg P1, S2
cmovg S2, S0
cmovg S0, P1
cmp P0, P2
