# n=5 model=out iset=I1 prefix14_class=13552
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmovl P1, P2
cmp S0, P3
mov P2, P3
cmovle P2, S0
cmovl S0, P3
cmp P1, P0
cmovge P3, P0
