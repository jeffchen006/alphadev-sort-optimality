# n=5 model=out iset=I1 prefix14_class=7736
mov S2, P3
cmp P1, P3
cmovge S2, P1
cmovl P3, P1
mov S1, P0
cmp P0, P2
cmovl P0, P2
mov S0, P3
cmovge S1, P2
cmp S0, S1
cmovg P3, S1
cmovle S0, S1
cmp P0, S2
cmovge S1, P0
