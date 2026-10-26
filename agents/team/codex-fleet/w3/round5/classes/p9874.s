# n=5 model=out iset=I1 prefix14_class=9874
mov S0, P2
cmp P0, P2
cmovg P2, P0
mov S1, P3
cmovl S0, P0
cmp P1, P3
cmovg P3, P1
cmovg P1, S1
cmovg S1, P3
cmp P2, P3
cmovg S1, P2
cmovle P3, P2
mov S1, P3
mov P2, P1
