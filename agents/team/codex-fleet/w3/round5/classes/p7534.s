# n=5 model=out iset=I1 prefix14_class=7534
cmp P3, P1
mov S1, P1
cmovg P1, P3
cmovl S1, P3
cmp P2, P0
cmovge P3, P0
mov S0, S1
cmovg P0, P2
cmovg P2, P3
cmp S1, P2
cmovle S0, P2
cmovle P2, S1
cmp P0, P1
cmovle P3, P0
