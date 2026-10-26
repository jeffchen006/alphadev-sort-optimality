# n=5 model=out iset=I1 prefix14_class=4933
mov S0, P3
cmp S0, P1
cmovl S0, P1
mov S2, P0
cmovg P3, P1
cmp S2, P2
cmovle S2, P2
cmovl P2, P0
cmp P3, P2
mov S1, S2
cmovge P0, P3
cmovge P3, P2
cmovg P2, P0
cmp S1, S0
