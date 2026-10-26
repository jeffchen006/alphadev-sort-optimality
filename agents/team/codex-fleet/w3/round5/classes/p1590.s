# n=5 model=out iset=I1 prefix14_class=1590
mov S2, P2
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
mov S1, P0
cmp P3, S1
cmovg S1, P3
mov S0, S2
cmovl P0, P3
cmp S0, P0
cmovle S2, P0
cmovg S0, P0
cmp P1, S1
cmovg P3, S1
