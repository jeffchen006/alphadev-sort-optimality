# n=5 model=out iset=I1 prefix14_class=7637
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
mov S0, P0
cmovle P3, S1
cmp P2, S0
cmovl S0, P2
cmovge P0, P2
cmp S0, P3
cmovle P2, S0
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
mov P2, P0
