# n=5 model=out iset=I1 prefix14_class=13944
mov S0, P2
cmp S0, P0
cmovg S0, P0
cmovle P2, P0
cmp P1, P3
cmovge P0, P1
cmovl P0, P3
cmovl P3, P1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovl P2, S2
mov P2, P3
cmp P2, S0
