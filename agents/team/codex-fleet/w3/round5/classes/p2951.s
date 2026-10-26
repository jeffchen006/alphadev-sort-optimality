# n=5 model=out iset=I1 prefix14_class=2951
cmp P2, P1
cmovge S0, P1
cmovle S0, P2
cmovg P1, P2
mov P2, P0
cmp P2, P3
cmovg P0, P3
cmovge P3, P2
mov P2, P3
cmp P1, P2
cmovle P3, P1
cmovl P1, P2
cmp S0, P0
cmovl P2, P3
