# n=5 model=out iset=I1 prefix14_class=2727
cmp P2, P0
mov S0, P2
cmovg P2, P0
cmovle S0, P0
cmp P3, P1
cmovge S1, P1
cmovle S1, P3
cmovle P3, P1
mov P1, S0
cmp P3, P1
cmovg P1, P3
cmovl S0, P3
cmp S1, P2
cmovge P1, S1
