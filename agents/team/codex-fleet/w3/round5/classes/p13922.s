# n=5 model=out iset=I1 prefix14_class=13922
cmp P1, P3
cmovle S0, P1
mov S2, P0
cmovl P1, P3
cmovl P3, S0
cmp P0, P2
cmovg P0, P2
cmovle S2, P2
cmp P1, S2
mov P2, S2
cmovg S2, P1
cmovg P1, P2
mov P2, P0
cmp P0, P3
