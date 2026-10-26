# n=5 model=out iset=I1 prefix14_class=7533
cmp P3, P0
mov S1, P0
cmovg P0, P3
cmovl S1, P3
mov S0, S1
cmp P2, P1
cmovge P3, P1
cmovg P1, P2
cmovg P2, P3
cmp S1, P2
cmovle S0, P2
cmovle P2, S1
cmp P1, P0
cmovle P3, P1
