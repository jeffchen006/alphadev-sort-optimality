# n=5 model=out iset=I1 prefix14_class=636
mov S0, P1
mov S1, P2
cmp P2, P0
cmovl P2, P0
cmovge S1, P0
cmp S0, P3
cmovge P1, P3
cmovge P3, S0
cmp P3, P2
mov S0, P3
cmovl P3, P2
cmovle P2, S0
cmp S1, P1
cmovge S0, P1
