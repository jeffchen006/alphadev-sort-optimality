# n=5 model=out iset=I1 prefix14_class=10031
mov S0, P0
cmp S0, P1
cmovg P0, P1
cmovle S0, P1
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovge P3, S1
cmp P3, S0
cmovle P1, P3
cmovle P3, S0
cmovl S0, P1
cmp P0, P2
cmovge P3, P2
