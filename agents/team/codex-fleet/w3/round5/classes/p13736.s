# n=5 model=out iset=I1 prefix14_class=13736
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
mov S2, P1
cmp S2, P0
cmovg P1, P0
cmovl S2, P0
mov P0, P3
cmp S2, P0
cmovge P3, S2
cmovg S2, P0
cmp P2, P1
mov P3, S2
