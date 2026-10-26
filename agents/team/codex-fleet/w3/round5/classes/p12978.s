# n=5 model=out iset=I1 prefix14_class=12978
cmp P0, P1
mov S1, P0
cmovl S1, P1
cmovg P0, P1
cmp P2, P3
mov P1, P3
cmovle P1, P2
cmovle P2, P3
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovg P1, S0
cmp P2, S1
cmovg P3, P2
