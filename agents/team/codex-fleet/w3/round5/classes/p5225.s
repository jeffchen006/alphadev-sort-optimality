# n=5 model=out iset=I1 prefix14_class=5225
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovle S0, P3
mov P3, P1
cmp P0, P3
cmovl P3, P0
cmovle P0, P1
cmp P3, P2
cmovge P1, P3
cmovle P1, P2
cmovge P3, P2
mov P3, S0
mov P2, P1
