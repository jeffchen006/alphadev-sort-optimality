# n=5 model=out iset=I1 prefix14_class=9840
mov S1, P2
cmp P0, P1
mov S2, P1
cmovg S2, P0
mov S0, S2
cmovl P1, P0
cmp S1, P3
cmovg P2, P3
cmovle S1, P3
cmp S2, S1
cmovle S0, S1
cmovge S2, S1
cmp P1, P2
cmovg S1, P2
