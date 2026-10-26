# n=5 model=out iset=I1 prefix14_class=6083
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovl P2, S0
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovg P1, P0
cmp S0, P3
cmovge P0, S0
cmovge S0, P3
cmovg P3, P0
cmp P1, P2
cmovg P3, P1
