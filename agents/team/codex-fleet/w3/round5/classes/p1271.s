# n=5 model=out iset=I1 prefix14_class=1271
cmp P0, P2
cmovle S2, P0
mov S0, P3
cmovg S2, P2
cmovl P0, P2
cmovge P2, P0
cmp S0, P1
cmovl S0, P1
cmovle P1, P3
cmp P2, S0
cmovg P2, S0
cmovl P0, S0
cmp S2, P1
mov P0, P2
