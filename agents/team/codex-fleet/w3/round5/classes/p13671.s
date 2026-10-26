# n=5 model=out iset=I1 prefix14_class=13671
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P3, P1
mov S0, P1
cmovge S0, P3
mov S2, S0
cmovg P3, P1
cmp S0, P0
cmovg S0, P0
cmovle S2, P0
mov S2, S0
cmp P3, P2
