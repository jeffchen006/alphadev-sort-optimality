# n=5 model=out iset=I1 prefix14_class=4656
cmp P3, P2
mov S0, P1
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
cmp P0, S0
cmovl S0, P0
cmovl P0, P1
mov S1, P2
cmp S1, P0
cmovle S1, P0
cmovge P2, P0
mov P1, S0
cmp P1, P3
