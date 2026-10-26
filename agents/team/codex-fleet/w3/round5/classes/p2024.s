# n=5 model=out iset=I1 prefix14_class=2024
mov S0, P1
cmp P3, S0
cmovg S0, P3
cmovge P3, P1
cmp P0, P2
mov S2, P2
cmovl P2, P0
cmovle P0, S2
cmovg S2, P0
cmp S2, S0
cmovl P0, S0
cmovg S2, S0
cmp P2, P3
mov P0, P3
