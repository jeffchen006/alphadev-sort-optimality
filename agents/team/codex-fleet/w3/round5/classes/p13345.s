# n=5 model=out iset=I1 prefix14_class=13345
mov S0, P2
cmp S0, P1
cmovge P2, P1
cmovle S0, P1
mov P1, P3
cmp P1, P0
cmovl P3, P0
cmovl P0, P1
mov P1, P0
cmp P2, P1
cmovg P0, P2
cmovl P1, P2
cmp P3, S0
cmovle P1, S0
