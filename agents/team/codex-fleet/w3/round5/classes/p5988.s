# n=5 model=out iset=I1 prefix14_class=5988
mov S0, P2
cmp P2, P3
cmovle P2, P3
cmovl P3, S0
cmp P0, P1
mov S0, P1
cmovge S0, P0
cmovle P1, P0
mov P0, S0
cmp P0, P2
cmovge P0, P2
cmovle S0, P2
cmp P1, P3
mov P2, P3
