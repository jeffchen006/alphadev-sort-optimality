# n=5 model=out iset=I1 prefix14_class=12808
cmp P1, P2
mov S2, P1
cmovle S2, P2
cmovl P2, P1
mov S1, P0
cmp S1, P3
cmovg S1, P3
cmovg P3, P0
cmp S1, P2
cmovg P1, S1
cmovge S1, P2
cmovg P2, P1
cmp P3, S2
cmovge S0, S2
