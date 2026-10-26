# n=5 model=out iset=I1 prefix14_class=8657
mov S0, P2
cmp S0, P0
cmovle S0, P0
cmovge P2, P0
cmp P1, P3
mov P0, P3
cmovle P3, P1
cmovle P1, P0
mov P0, S0
cmp P0, P1
cmovl P0, P1
cmovge S0, P1
cmp P2, P3
cmovg P1, P2
