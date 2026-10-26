# n=5 model=out iset=I1 prefix14_class=8574
cmp P3, P2
cmovle S0, P3
mov S2, P0
cmovle P3, P2
cmovle P2, S0
cmp S2, P1
cmovge P0, P1
cmovle S2, P1
mov P1, S2
cmp P1, P3
cmovl S2, P3
cmovle P3, P1
cmovg P1, P3
mov S2, P0
