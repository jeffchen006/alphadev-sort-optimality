# n=5 model=out iset=I1 prefix14_class=5037
cmp P0, P1
mov S2, P3
cmovg S0, P1
cmovg P1, P0
cmovle S0, P0
cmp S2, P2
cmovl S2, P2
cmovl P2, P3
cmovge P3, P2
cmp S0, P3
cmovge P2, S0
cmovle P3, S0
cmp P1, S2
cmovg P0, S2
