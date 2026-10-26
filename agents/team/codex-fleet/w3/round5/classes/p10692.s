# n=5 model=out iset=I1 prefix14_class=10692
mov S2, P3
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmovl P3, P1
cmp P0, P1
cmovl P1, P0
cmovle P0, P3
cmp S2, P2
cmovge P3, S2
