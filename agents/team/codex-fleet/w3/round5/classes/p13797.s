# n=5 model=out iset=I1 prefix14_class=13797
mov S1, P0
cmp P0, P2
mov S2, P3
cmovl S1, P2
cmovg P0, P2
cmp S2, P1
cmovl P3, P1
cmovg S2, P1
mov S0, P3
cmp S0, S1
cmovl S0, S1
cmovge P3, S1
cmp P0, S2
cmovle S0, P0
